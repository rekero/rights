# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: "Star Wars" }, { name: "Lord of the Rings" }])
#   Character.create(name: "Luke", movie: movies.first)
transaction_types = {
  'Download Albums' => 0.3,
  'Subscription Audio Streams' => 0.5,
  'Ad-Supported Audio Streams' => 0.5,
  'Non-interactive Radio' => 0.5,
  'Cloud Match Units' => 0.5,
  'Mid-Tier Subscription Audio Streams' => 0.5,
  'Physical Sales' => 0.15,
  'Download Tracks' => 0.3,
}
TransactionType.delete_all
Artist.delete_all
Track.delete_all
Album.delete_all
Sale.delete_all
transaction_types.keys.each do |key|
  TransactionType.create!(name: key, proportion: transaction_types[key])
end

tracks_file = File.read('./db/tracks.json')
sales_file = File.read('./db/sales-reports.json')

tracks_hash = JSON.parse(tracks_file)
sales_hash = JSON.parse(sales_file)
tracks_hash.each do |track|
  artist_id = Artist.find_or_create_by(name: track['Artist Name']).id
  album_id = Album.find_or_create_by(
    artist_id: artist_id,
    upc: track['UPC'],
    release_title: track['Release title'],
    release_year: ['Release year']
  ).id
  Track.find_or_create_by(album_id: album_id, isrc: track['ISRC'], name: track['Track Title'], artist_id: artist_id)
end
sales_hash.each do |sale|
  transaction_type = TransactionType.find_by(name: sale['Trans Type Description'])
  origin = transaction_type.release_sale? ? Album.find_by(upc: sale['product code']) : Track.find_by(isrc: sale['product code'])
  Sale.create(
    origin: origin,
    transaction_type_id: transaction_type.id,
    revenue_for_label: sale['Label Share Net Receipts']*(1-transaction_type.proportion),
    revenue_for_artist: sale['Label Share Net Receipts']*transaction_type.proportion
  )
end