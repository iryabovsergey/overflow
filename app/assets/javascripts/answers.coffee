active_answer_id = 0;
a_bind = false

hideActiveAnswerForm = () ->
  if(active_answer_id>0)
    $('#actions_answer_'+active_answer_id).show()
    $('#form_edit_answer_'+active_answer_id).hide()
    active_answer_id = 0

edit_cancel_actions_answer = () ->
  $('body').on 'click', '.edit_answer_link', (e) ->
    answer_id = undefined
    e.preventDefault()
    hideActiveAnswerForm()
    answer_id = $(this).data('answerId')
    $('#actions_answer_' + answer_id).hide()
    $('#form_edit_answer_' + answer_id).show()
    active_answer_id = answer_id;

  $('body').on 'click', '.cancel_edit_answer_link', (e) ->
    e.preventDefault()
    hideActiveAnswerForm()

$(document).ready(edit_cancel_actions_answer)
$(document).on('turbolinks:load', edit_cancel_actions_answer)


