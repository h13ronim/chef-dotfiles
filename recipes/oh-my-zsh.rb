#
# Cookbook Name:: dotfiles
# Recipe:: oh-my-zsh
#
# Copyright 2015, Marcin Michałowski
#
# Permission is hereby granted, free of charge, to any person obtaining
# a copy of this software and associated documentation files (the
# "Software"), to deal in the Software without restriction, including
# without limitation the rights to use, copy, modify, merge, publish,
# distribute, sublicense, and/or sell copies of the Software, and to
# permit persons to whom the Software is furnished to do so, subject to
# the following conditions:
#
# The above copyright notice and this permission notice shall be
# included in all copies or substantial portions of the Software.
#
# THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
# EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF
# MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND
# NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE
# LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION
# OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION
# WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
#

package 'zsh' do
  action :install
end

git "#{Etc.getpwnam(node['user']['id']).dir}/.oh-my-zsh" do
  repository 'https://github.com/robbyrussell/oh-my-zsh.git'
  revision 'master'
  action :checkout
end

git "#{Etc.getpwnam(node['user']['id']).dir}/.oh-my-zsh-custom" do
  repository 'git@github.com:h13ronim/oh-my-zsh-custom.git'
  revision 'master'
  action :checkout
  user node['user']['id']
end

link "#{Etc.getpwnam(node['user']['id']).dir}/.zshrc" do
  to "#{Etc.getpwnam(node['user']['id']).dir}/.oh-my-zsh-custom/zshrc"
end

execute 'echo "/usr/local/bin/zsh" | sudo tee -a /etc/shells' do
  not_if 'grep /usr/local/bin/zsh /etc/shells'
end

execute 'chsh -s /usr/local/bin/zsh' do
  not_if '[ "$SHELL" = "/usr/local/bin/zsh" ]'
end
