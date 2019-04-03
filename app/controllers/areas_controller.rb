class AreasController < ApplicationController
  require 'net/http'
  require 'uri'
  require 'json'

  def index
    @areas = Area.all
  end

  def search
    @area = Area.new
    if params[:zipcode]
      begin
        uri = URI.parse("http://zipcloud.ibsnet.co.jp/api/search?zipcode=#{params[:zipcode]}")
        @query = uri.query
        response = Net::HTTP.get_response(uri)
        # responseの値に応じて処理を分ける
        case response
          # 成功した場合
        when Net::HTTPSuccess
          # responseのbody要素をJSON形式で解釈し、hashに変換
          @result = JSON.parse(response.body)
          # 表示用の変数に結果を格納
          @area.zipcode = @result["results"][0]["zipcode"]
          @area.prefcode = @result["results"][0]["prefcode"]
          @area.address1 = @result["results"][0]["address1"]
          @area.address2 = @result["results"][0]["address2"]
          @area.address3 = @result["results"][0]["address3"]
          @area.kana1 = @result["results"][0]["kana1"]
          @area.kana2 = @result["results"][0]["kana2"]
          @area.kana3 = @result["results"][0]["kana3"]
        end
          # エラー時処理
      rescue IOError
        flash.now[:alert] = @result["message"]
      rescue TimeoutError
        flash.now[:alert] = @result["message"]
      rescue JSON::ParserError
        flash.now[:alert] = @result["message"]
      rescue
        flash.now[:alert] = @result["message"]
      end
    end
  end

  def create
    @area = Area.new(area_params)
    if @area.save
      flash[:notice] = "地域を登録しました。"
      redirect_to root_path
    else
      flash[:alert] = "Validation failed: #{@area.errors.full_messages.join}"
      redirect_to "/areas/search?zipcode=#{params[:area][:zipcode]}"
    end
  end

  private

  def area_params
    params.require(:area).permit(:zipcode, :prefcode, :address1, :address2, :address3, :kana1, :kana2, :kana3, :introduction)
  end

end
