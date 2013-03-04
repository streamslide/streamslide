#= require s3_direct_upload

jQuery ->
  has_file = false
  uploader = $("#myS3Uploader").S3Uploader
    remove_completed_progress_bar: false
    before_add: (file)->
      if not has_file and file.type == 'application/pdf'
        has_file = true
        true
      else
        false

  get_job_status = (job_id) ->
    $.getJSON '/upload/job/?job_id=' + job_id, (data) ->
      if parseInt(data.total_page) > 0
        progress = parseInt(data.processed_page / data.total_page * 50, 10)
        $("#processing_bar").css("width", progress + "%")

      callback = () -> get_job_status(job_id)

      switch data.status
        when "complete"
          $(".btn.disable").toggleClass("disable")
        when "processing"
          setTimeout callback, 2000

  uploader.on 'ajax:complete', (xhr, status) ->
    $("#processing_bar").addClass "bar"
    job_id = $.parseJSON(status.responseText).job_id

    get_job_status(job_id)
