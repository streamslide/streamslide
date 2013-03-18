class NotesController < ApplicationController

  def index
    slide_id = params[:s]
    pagenum = params[:p]

    notes = Note.where("user_id = ? AND slide_id = ? AND pagenum = ?", current_user.id, slide_id, pagenum)
    render json: notes
  end

  def create
    user_id = current_user.id
    slide_id = params[:note][:slide_id]
    pagenum = params[:note][:pagenum]

    newnote = Note.create(user_id: user_id, slide_id: slide_id, pagenum: pagenum, top: params[:note][:top], left: params[:note][:left], content: params[:note][:content])
    render json: newnote
  end

  def update

  end

  def destroy
    Note.destroy(params[:id])
    render json: {'success'=>true}
  end

end
