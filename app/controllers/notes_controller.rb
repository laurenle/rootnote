class NotesController < ApplicationController
  before_action :confirm_folder_ownership
  before_action :set_folder_note, only: [:show, :edit, :update, :destroy]

  # GET /folders/1/notes
  # GET /notes.json
  def index
    @notes = Note.all
  end

  # GET /folders/1/notes/1
  # GET /notes/1.json
  def show
  end

  # GET /folders/1/notes/new
  def new
    @folder = Folder.find(params[:folder_id])
    @note = Note.new
  end

  # GET /folders/1/notes/1/edit
  def edit
  end

  # POST /folders/1/notes
  # POST /folders/1/notes.json
  def create
    @folder = Folder.find(params[:folder_id])
    @note = Note.new(note_params)

    respond_to do |format|
      if @note.save
        format.html { redirect_to [@folder, @note], notice: 'Note was successfully created.' }
        format.json { render :show, status: :created, location: @note }
      else
        format.html { render :new }
        format.json { render json: @note.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /folders/1/notes/1
  # PATCH/PUT /folders/1/notes/1.json
  def update
    respond_to do |format|
      if @note.update(note_params)
        format.html { redirect_to [@folder, @note], notice: 'Note was successfully updated.' }
        format.json { render :show, status: :ok, location: @note }
      else
        format.html { render :edit }
        format.json { render json: @note.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /folders/1/notes/1
  # DELETE /folders/1/notes/1.json
  def destroy
    @note.destroy
    respond_to do |format|
      format.html { redirect_to folder_url(@folder), notice: 'Note was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_folder_note
      @folder = Folder.find(params[:folder_id])
      @note = Note.find(params[:id])
    end

    def confirm_folder_ownership
      folder = Folder.find(params[:folder_id])
      redirect_to folders_url unless folder.user_id == current_user.id
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def note_params
      params.require(:note).permit(:title, :body, :folder_id)
    end
end
