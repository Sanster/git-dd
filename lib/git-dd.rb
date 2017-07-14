# encoding: utf-8

require 'tty-prompt'

class GitDD
  def run
    branches = `git branch`
    branches = branches.split("\n")
  end

  private

  def current_branch

  end
end
