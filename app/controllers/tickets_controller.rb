class TicketsController < ApplicationController
  def new
    @ticket = Ticket.new
  end

  def create
    client = ZendeskApiInit.client
    ZendeskAPI::Ticket.create!(client, :subject => params[:ticket][:subject],
      :recipient => params[:ticket][:recipient],
      :description => params[:ticket][:description ] )
    redirect_to root_path
  end

  private
    def ticket_params
      params.require(:ticket).permit(:recipient, :subject, :description)
    end
end
