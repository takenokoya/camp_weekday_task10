class AreasController < ApplicationController
  def index
    @areas = Area.all
  end

  def new
    @area = Area.new
  end

  def create
    @area = Area.new(area_params)
    @area.save
    redirect_to @area, notice: "地域を登録しました。"
  end

  def search
    
  end

  private

  def area_params
    params.require(:area).permit(:zipcode, :prefcode, :address1, :address2, :address3, :kana1, :kana2, :kana3, :introduction)
  end
end
