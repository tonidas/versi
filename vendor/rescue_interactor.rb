require "interactor"

module RescueInteractor
  def self.included(base)
    base.include(Interactor)
    base.around do |interactor|
      begin
        interactor.call
      rescue Exception => exception
        context.fail!(error: exception)
      end
    end
  end
end
