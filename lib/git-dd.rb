# encoding: utf-8

require 'tty-prompt'
require 'rainbow/ext/string'

class GitDD
  def run
    branch_names = `git branch`
    return if $?.exitstatus != 0

    branch_names = branch_names.split("\n")

    branches_with_more_info = `git branch -vv`
    branches_with_more_info = branches_with_more_info.split("\n")

    return if branch_names.size != branches_with_more_info.size

    branches = {}
    branch_names.each_with_index { |b, i| branches[b] = branches_with_more_info[i] }

    if branches.size == 1
      puts "You only have one branch."
      return
    end

    branches = branches.select { |k, v| k != current_branch_with_mark && !k.include?("* (HEAD detached at") }

    puts "Current branch is: #{current_branch.color(:green)}"

    prompt = TTY::Prompt.new(interrupt: :exit)

    prompt.on(:keypress) do |event|
      if event.value == 'q'
        return
      end
    end

    branches_to_delete = prompt.multi_select("Choose branches to delete:", per_page: 20, help: '',echo: false) do |menu|
      branches.each { |k, v| menu.choice v, k}
    end

    if branches_to_delete.size == 0
      puts "No branch selected"
      return
    end

    branches_to_delete.each { |b| puts b.color(:red) }

    ensure_delete = !prompt.no?('Are you sure?')

    if ensure_delete
      branches_to_delete.each do |b|
        puts `git branch -D #{b}`.chomp.color(:yellow)
      end
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
