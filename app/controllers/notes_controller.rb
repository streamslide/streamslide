class NotesController < ApplicationController

  def index
    note = Note.first
    render json: note
  end

  def create
    binding.pry
  end
end
