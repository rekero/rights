class StatisticsController < ApplicationController
  def tracks
    @artist_id = params[:artist_id]
    @release_year = params[:release_year]
    are_params = @artist_id.present? || @release_year.present?
    @tracks = are_params ? Track.includes(:album).joins(:album) : Track.none
    @tracks = @tracks.where('albums.artist_id = ?', @artist_id) if @artist_id.present?
    @tracks = @tracks.where('albums.release_year = ?', @release_year) if @release_year.present?
  end

  def revenue
    @money_from_albums = Album.joins(:sales).select('artist_id, SUM(sales.revenue_for_label) AS label_sum, SUM(sales.revenue_for_artist) AS artist_sum, SUM(sales.revenue_for_label + sales.revenue_for_artist) AS full_sum').group(:artist_id)
    @money_from_tracks = Track.joins(:sales).select('artist_id, SUM(sales.revenue_for_label) AS label_sum, SUM(sales.revenue_for_artist) AS artist_sum, SUM(sales.revenue_for_label + sales.revenue_for_artist) AS full_sum').group(:artist_id)
    @artists = Artist.all.map do |artist|
      album = @money_from_albums.detect { |sale| artist.id == sale.artist_id }
      track = @money_from_tracks.detect { |sale| artist.id == sale.artist_id }
      {
        name: artist.name,
        label_sum: nullify(track&.label_sum) + nullify(album&.label_sum),
        artist_sum: nullify(track&.artist_sum) + nullify(album&.artist_sum),
        full_sum: nullify(track&.full_sum) + nullify(album&.full_sum)
      }
    end
  end

  private

  def nullify(value)
    value.present? ? value : 0
  end
end