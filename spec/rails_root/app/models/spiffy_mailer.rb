class SpiffyMailer < ActionMailer::Base
  def spiffy_mail
    @recipients = 'foo@example.com'
    @subject = 'Desert Email'
    @from = "desert@example.com"
  end
end
