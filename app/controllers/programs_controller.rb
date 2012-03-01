class ProgramsController < ApplicationController
  def index
    @programs = Program.all
  end

  def new
  end

  def show
    @program = Program.find request[:id]
  end

  def edit
    @program = Program.find request[:id]
  end

end
