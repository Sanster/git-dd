# encoding: utf-8

require 'tty-prompt'
require 'rainbow/ext/string'
require_relative './git-dd/const.rb'

class GitDD
  attr_accessor :prompt
  MERGED = "merged"
  UNMERGE = "unmerge"

  def run(test_prompt = nil)
    branch_names = `git branch`
    return if $?.exitstatus != 0

    branch_names = branch_names.split("\n")

    branches_vv =
      begin
        str = `git branch -vv`
        str.split("\n")
      rescue
        str = `git branch`
        str.split("\n")
      end

    return if branch_names.size != branches_vv.size

    branches_for_select = {}
    branch_names.each_with_index { |b, i| branches_for_select[b] = branches_vv[i] }

    if branches_for_select.size == 1
      return print(ONLY_ONE_BRANCH)
    end

    branches_for_select = branches_for_select.select { |k, v| k != current_branch_with_mark && !k.include?("* (HEAD detached at") }

    puts "Current branch is: #{current_branch.color(:green)}"

    if test_prompt
      prompt = test_prompt
    else
      prompt = TTY::Prompt.new(interrupt: :exit)
    end
    prompt.on(:keypress) { |event| return if event.value == 'q' }

    branches_for_select.each do |k, v|
      branches_for_select[k] =
        if merged?(k)
          MERGED.color(:green) + " " + v
        else
          UNMERGE.color(:red) + v
        end
    end

    branches_to_delete = prompt.multi_select("Choose branches to delete:", per_page: 20, help: '',echo: false) do |menu|
      branches_for_select.each { |k, v| menu.choice(v, k) }
    end

    if branches_to_delete.size == 0
      return print(NO_BRANCH_SELECTED)
    end

    branches_to_delete.each do |b|
      puts " "*4 + branches_for_select[b]
    end

    ensure_delete = !prompt.no?('Are you sure?')

    if ensure_delete
      branches_to_delete.each do |b|
        puts `git branch -D #{b}`.chomp.color(:yellow)
      end
    end

    return branches_to_delete
  end

  private

  def current_branch_with_mark
    @current_branch_with_mark ||= "* #{current_branch}"
  end

  def current_branch
    @current_branch ||= `git rev-parse --abbrev-ref HEAD`.chomp
  end

  def merged_branch_names
    return @merged_branches if @merged_branches

    @merged_branches = `git branch --merged`
    @merged_branches = @merged_branches.split("\n")

    @merged_branches = @merged_branches.select { |b| b != current_branch_with_mark }
  end

  def merged?(branch_name)
    merged_branch_names.include? branch_name
  end

  def print(return_message)
    puts return_message
    return_message
  end
end
