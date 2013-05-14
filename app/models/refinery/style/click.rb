# require 'geoip'
# require 'useragent'

class Refinery::Style::Click < ActiveRecord::Base
  attr_accessible :agent, :choices, :referer, :remote_ip

  belongs_to :game
  belongs_to :result, :class_name => 'Refinery::Style::Style'
  has_many :clicks_images
  has_many :choices, :source => :image, :through => :clicks_images

  # GeoIPDataPath = File.absolute_path File.join(__FILE__, "../../../../../config")

  def trace env, choices, result
    # logger.info(env)

    self.remote_ip = (env["HTTP_X_FORWARDED_FOR"] || env["REMOTE_ADDR"]).to_s
    self.agent = env["HTTP_USER_AGENT"].to_s
    self.choices = choices
    self.result = result
    # self.country = geo_ip.country(self.remote_ip).country_name.to_s
    # self.browser = user_agent.browser.to_s
    # self.platform = user_agent.platform.to_s
  end

  # def user_agent
  #   @user_agent ||= UserAgent.parse(self.agent)
  # end

  # def geo_ip
  #   @geo_ip ||= GeoIP.new(File.join(GeoIPDataPath, 'GeoIP.dat'))
  # end

  # def geo_lite_city
  #   @geo_ip ||= GeoIP.new(File.join(GeoIPDataPath, 'GeoLiteCity.dat'))
  # end
end
