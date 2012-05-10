class ReservationsController < ApplicationController
  
  def create
    @book = Book.find(params[:book_id])
    @reservation = @book.reservations.new
    @reservation.user = current_user

    if @reservation.save
      UserMailer.reservation_confirmation(current_user, @book).deliver
      flash[:notice] = "Book reserved"
      respond_to do |format|
        format.html { redirect_to book_path(@book) }
        format.json { render json: @reservation.to_json(include: :user) }
      end
    else
      render :new
    end
  end
  
  def free
    @book = Book.find(params[:book_id])
    @reservation = @book.reservations.where(id: params[:id], user_id: current_user.id).first
   
    if @reservation && @reservation.free
      flash[:notice] = "Book is no longer reserved"
    else
      flash[:error]  = "Something went wrong"
    end
    redirect_to book_path(@book)
  end
  
end
