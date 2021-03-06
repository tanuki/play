module Play
  # API endpoints for Airfoil speaker controls.
  class App < Sinatra::Base
    # Validates speaker id, send 404 if invalid.
    #
    # id - Airfoil speaker id to check.
    #
    # Returns nothing.
    def validate_speaker_id(id)
      if !Speaker.valid_id?(id)
        halt 404
      end
    end

    get "/speakers" do
      speakers = {
        :speakers => Airfoil.get_speakers.map { |speaker| speaker.to_hash }
      }.to_json
    end

    get "/speaker/:id" do
      validate_speaker_id(params[:id])

      speaker = {
        :speaker => Speaker.new(params[:id]).to_hash
      }.to_json
    end

    get "/speaker/:id/volume" do
      validate_speaker_id(params[:id])

      speaker = Speaker.new(params[:id])
      "%d" % (speaker.volume * 100)
    end

    put "/speaker/:id/volume" do
      validate_speaker_id(params[:id])

      speaker = Speaker.new params[:id]
      speaker.volume = params[:volume].to_i / 100.0
      "%d" % (speaker.volume * 100)
    end

    put "/speaker/:id/connect" do
      validate_speaker_id(params[:id])

      speaker = Speaker.new params[:id]
      speaker.connect!
      speaker = {
        :speaker => speaker.to_hash
      }.to_json
    end

    put "/speaker/:id/disconnect" do
      validate_speaker_id(params[:id])

      speaker = Speaker.new params[:id]
      speaker.disconnect!
      speaker = {
        :speaker => speaker.to_hash
      }.to_json
    end
  end
 end
