active_question_id = 0
active_obj_id = 0
q_bind = false
received_object_id = '';

hideActivequestionForm = () ->
  if(active_obj_id > 0)
    $('#comments_form_obj_' + active_obj_id).hide()
    active_obj_id = 0
  if(active_question_id > 0)
    $('#actions_question_' + active_question_id).show()
    $('#form_edit_question_' + active_question_id).hide()
    active_question_id = 0

edit_cancel_actions = () ->
  if(!q_bind)
    q_bind = true

    $('body').on 'click', '.add_comment', (e) ->
      e.preventDefault()
      hideActivequestionForm()
      active_obj_id = $(this).data('objId')
      $('#comments_form_obj_' + active_obj_id).show()

    $('body').on 'click', '.comments_cancel', (e) ->
      e.preventDefault()
      hideActivequestionForm()

    $('body').on 'click', '.edit_question_link', (e) ->
      question_id = undefined
      e.preventDefault()
      hideActivequestionForm()
      question_id = $(this).data('questionId')
      $('#actions_question_' + question_id).hide()
      $('#form_edit_question_' + question_id).show()
      active_question_id = question_id;

    $('body').on 'click', '.cancel_edit_question_link', (e) ->
      e.preventDefault()
      hideActivequestionForm()

    $('.give_vote').bind 'ajax:success', (e, data, status, xhr) ->
      answer = $.parseJSON(xhr.responseText)
      div_id = $(this).data('divId')
      $('.notices').html('Your vote make sence')
      $('.errors').html('')
      $('#' + div_id).html(answer.score)

    .bind 'ajax:error', (e, xhr, status, error) ->
      if(status==403)
        alert('You are not authorized to perform the action')
      else
        errors = $.parseJSON(xhr.responseText)
        $('.notices').html('')
        $('.errors').html(errors.errors.join('<br>'))

    if gon.question_id
      App.cable.subscriptions.create(channel: 'QuestionsChannel', question_id: gon.question_id, {
        received: (data) ->
          if gon.user_id != data.author_id
            if(data.comments)
              appendComments(data)
            if(data.answer)
              appendAnswer(data)
      })
    else
      App.cable.subscriptions.create(channel: 'QuestionsChannel', {
        received: (data) ->
          if gon.user_id != data.author_id
            if(data.question)
              appendQuestion(data)

            if(data.comments)
              appendComments(data)
      })

appendComments = (data) ->
  comment_div = '#comments_obj_' + data.id;
  $(comment_div).html('')
  i = 0
  while i < data.comments.length
    $(comment_div).append JST['comment']({comment: data.comments[i]})
    i++

appendAnswer = (data) ->
  $('#new_answers').append JST['answer']({
    answer: data.answer,
    author: data.author,
    attachments: data.attachments,
    answer_url: data.answer_url,
    answer_score: data.answer_score,
    vp_url: data.vp_url,
    vm_url: data.vm_url,
    vc_url: data.vc_url
  })

appendQuestion = (data) ->
  $('#new_questions').append JST['question']({
    question: data.question,
    author: data.author,
    attachments: data.attachments,
    question_url: data.question_url,
    question_score: data.question_score,
    vp_url: data.vp_url,
    vm_url: data.vm_url,
    vc_url: data.vc_url
  })

$(document).ready(edit_cancel_actions)
$(document).on('turbolinks:load', edit_cancel_actions)