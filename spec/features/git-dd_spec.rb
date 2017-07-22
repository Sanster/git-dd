# encoding: utf-8
require 'spec_helper.rb'

RSpec.describe "git-dd feature test" do
  before do
    `mkdir tmp`
    Dir.chdir('tmp')
    `git init`
    `touch .keep`
    `git add .`
    `git commit -m "test"`
  end

  after do
    Dir.chdir('../')
    `rm -rf tmp`
  end

  context "Repository has more than one branch" do
    before do
      `git checkout -q -b t1`
      `git checkout -q -b t2`
      `git checkout -q -b t3`
      `git checkout -q master`
    end

    it 'delete nothing when press enter immediately' do
      prompt = TTY::TestPrompt.new
      prompt.input << "\r"
      prompt.input.rewind

      expect(GitDD.new.run(prompt)).to eq(NO_BRANCH_SELECTED)
    end

    it 'delete t1 branch when press space once' do
      prompt = TTY::TestPrompt.new
      prompt.input << " \r"
      prompt.input << "y\r"
      prompt.input.rewind

      expect(GitDD.new.run(prompt)).to eq(["  t1"])
    end

    it 'delete all branch' do
      prompt = TTY::TestPrompt.new
      prompt.input << " " << "j"
      prompt.input << " " << "j"
      prompt.input << " " << "j"
      prompt.input << "y\r"
      prompt.input.rewind
      prompt.on(:keypress) do |event|
        prompt.trigger(:keydown) if event.value == "j"
      end

      expect(GitDD.new.run(prompt)).to eq(["  t1","  t2", "  t3"])
    end
  end

  context "Repository has only one branch" do
    it 'prompt only one branch' do
      prompt = TTY::TestPrompt.new

      expect(GitDD.new.run(prompt)).to eq(ONLY_ONE_BRANCH)
    end
  end
end