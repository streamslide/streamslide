#= require s3_direct_upload
jQuery ->
  has_file = false
  $("#myS3Uploader").S3Uploader
    remove_completed_progress_bar: false
    before_add: (file)->
      if not has_file and file.type == 'application/pdf'
        has_file = true
        true
      else
        false

