# encoding: utf-8

require 'tty-prompt'
require 'rainbow/ext/string'

class GitDD
  def run
    branches = `git branch`
    return if $?.exitstatus != 0

    if branches.size == 1
      puts "You only have one branch."
      return
    end

    branches = branches.split("\n").select do |b|
      b != current_branch_with_mark && !b.include?("* (HEAD detached at")
    end


    puts "Current branch is: #{current_branch.color(:green)}"

    prompt = TTY::Prompt.new(interrupt: :exit)

    prompt.on(:keypress) do |event|
      if event.value == 'q'
        return
      end
    end

    branches_to_delete = prompt.multi_select("Choose branches to delete:", branches, per_page: 20, help: '')

    ensure_delete = !prompt.no?('Are you sure?')

    if ensure_delete
      branches_to_delete.each { |b| puts `git branch -D #{b}`}
    end
  end

  private

  def current_branch_with_mark
    @current_branch_with_mark ||= "* #{current_branch}"
  end

  def current_branch
    @current_branch ||= `git rev-parse --abbrev-ref HEAD`.chomp
  end
end
