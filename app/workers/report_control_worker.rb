class ReportControlWorker
  include Sidekiq::Worker

  def perform(report_id)
    make_report(report_id)
  end

  private

  def make_report(report_id)
    report         = Report.find(report_id)
    report_service = ReportService.new(report)
    report_body    = report_service.body
    report.update( body: report_body)
  end

end