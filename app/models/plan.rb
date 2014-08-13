# -*- coding: utf-8 -*-
# This file is part of Mconf-Web, a web application that provides access
# to the Mconf webconferencing system. Copyright (C) 2010-2012 Mconf
#
# This file is licensed under the Affero General Public License version
# 3 or later. See the LICENSE file.

class Plan < ActiveRecord::Base
  has_many :subscription

  validates :name, presence: true
  validates :code, presence: true
  validates :amount, presence: true
  validates :currency, presence: true
  validates :interval, presence: true
  validates :interval_count, presence: true

end
