# encoding: utf-8

require 'tty-prompt'
require 'rainbow/ext/string'
require_relative './git-dd/const.rb'

class GitDD
  attr_accessor :prompt
  MERGED = "merged"
  UNMERGE = "unmerge"
  DETACHED = "* (HEAD detached at"

  def initialize(test_prompt = nil)
    if test_prompt
      @prompt = test_prompt
    else
      @prompt = TTY::Prompt.new(interrupt: :exit)
    end

    @prompt.on(:keypress) { |event| exit 1 if event.value == 'q' }
  end

  def delete_merged_branches()
    puts "Branches have been merged into: #{current_branch.color(:green)}"

    merged_branches.each { |b| puts " "*4 + branches_for_select[b][16..-1] }

    ensure_delete = !prompt.no?('Are you sure?')

    merged_branches.each { |b| delete(b) } if ensure_delete

    return merged_branches
  end

  def select_branches_to_delete()
    return if branches.size != branches_vv.size
    return print(ONLY_ONE_BRANCH) if branches_for_select.size == 0

    puts "Current branch is: #{current_branch.color(:green)}"

    prompt_options = { per_page: 20, help: '', echo: false }
    prompt_help = "Choose branches to delete:"
    branches_to_delete = @prompt.multi_select(prompt_help, prompt_options) do |menu|
      branches_for_select.each { |k, v| menu.choice(v, k) }
    end

    return print(NO_BRANCH_SELECTED) if branches_to_delete.size == 0

    branches_to_delete.each { |b| puts " "*4 + branches_for_select[b] }

    ensure_delete = !prompt.no?('Are you sure?')

    branches_to_delete.each { |b| delete(b) } if ensure_delete

    return branches_to_delete
  end

  private

  def current_branch_with_mark
    @current_branch_with_mark ||= "* #{current_branch}"
  end

  def current_branch
    @current_branch ||= `git rev-parse --abbrev-ref HEAD`.chomp
  end

  def merged_branches
    return @merged_branches if @merged_branches

    @merged_branches = `git branch --merged`
    @merged_branches = @merged_branches.split("\n")

    @merged_branches = @merged_branches.select { |b| b != current_branch_with_mark }
  end

  def branches
    return @branches if @branches

    @branches = `git branch`
    @branches = @branches.split("\n")
  end

  def branches_vv
    @branches_vv ||=
      begin
        str = `git branch -vv`
        str.split("\n")
      rescue
        str = `git branch`
        str.split("\n")
      end
  end

  def branches_for_select
    return @branches_for_select if @branches_for_select

    @branches_for_select = {}
    branches.each_with_index { |b, i| @branches_for_select[b] = branches_vv[i] }

    @branches_for_select = @branches_for_select.select \
      { |k, v| k != current_branch_with_mark && !k.include?(DETACHED) }

    @branches_for_select.each do |k, v|
      @branches_for_select[k] =
        if merged?(k)
          MERGED.color(:green) + " " + v
        else
          UNMERGE.color(:red) + v
        end
    end
  end

  def merged?(branch)
    merged_branches.include? branch
  end

  def print(return_message)
    puts return_message
    return_message
  end

  def delete(branch)
    puts `git branch -D #{branch}`.chomp.color(:yellow)
  end
end
