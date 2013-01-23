#= require s3_direct_upload
jQuery ->
  $("#myS3Uploader").S3Uploader
    remove_completed_progress_bar: false
    before_add: (file)->
      if file.type == 'application/pdf'
        true
      else
        alert "Unsuported file"
        false

