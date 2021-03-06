$(->
  init()
)

init = (scope = document) ->
  $('[data-trigger="[dropdown/toggle]"]', scope).off 'click'
  $('[data-trigger="[dropdown/toggle]"]', scope).on 'click', ->
    $('.expand').not($('.expand', @.parentElement)).slideUp()
    $('.menu > ul > li > a').not($(@)).removeClass 'navActive'
    $(@).toggleClass 'navActive'
    $('.expand', @.parentElement).slideToggle()

    return

  modal_open = ->
    $('.overlay').fadeIn 'fast'
    $('[data-component=\'' + @.getAttribute('data-trigger-target') + '\']').fadeIn 'fast'
    return

  $('[data-trigger=\'[modal/open]\']', scope).off 'click'
  $('[data-trigger=\'[modal/open]\']', scope).on 'click', modal_open

  server_item = ->
    $(@).toggleClass 'toggableListActive'
    $(@).find('.content').fadeToggle 'fast'
    return

  $('[data-trigger=\'[server/item]\']', scope).off 'click'
  $('[data-trigger=\'[server/item]\']', scope).on 'click', server_item


  modal_close = ->
    $('.overlay').fadeOut 'fast'

    parent = @.parentElement
    until $(parent).hasClass('modal')
      parent = parent.parentElement

    $(parent).fadeOut 'fast'
    return

  $('[data-trigger=\'[modal/close]\']', scope).off 'click'
  $('[data-trigger=\'[modal/close]\']', scope).on 'click', modal_close


  overlay = ->
    $('.overlay').fadeOut 'fast'
    $('.modal').fadeOut 'fast'
    return

  $('.overlay', scope).off 'click'
  $('.overlay', scope).on 'click', overlay


  system_messages_open = ->
    $('.notificationsArea', @).fadeToggle 'fast'
    $($('a', @)[0]).toggleClass 'userMenuActive'
    return

  $('[data-trigger=\'[system/messages/open]\']', scope).off 'click'
  $('[data-trigger=\'[system/messages/open]\']', scope).on 'click', system_messages_open


  $('.searchOverlay', scope).off 'click'
  $('.searchOverlay', scope).on 'click', ->
    $('.searchOverlay').fadeOut 'fast'
    $('.searchArea').fadeOut 'fast'
    $('.search').animate {width: '20%'}, 250
    return


  $('[data-trigger="[announcement/expand]"]', scope).off 'click'
  $('[data-trigger="[announcement/expand]"]', scope).on 'click', ->
    $('.announcement-expand', @).slideToggle()
    return


  $('[data-trigger="[user/toggle]"]', scope).off 'click'
  $('[data-trigger="[user/toggle]"]', scope).on 'click', ->
    $('.dropdown', @).fadeToggle 'fast'
    return


  $('.search input', scope).off 'click'
  $('.search input', scope).on 'click', ->
    $('.modal').fadeOut 'fast'
    $('.searchOverlay').fadeIn 'fast'
    $('.searchArea').fadeToggle 'fast'
    $('.search').animate {width: '30%'}, 250
    return


  $('.timeTable tbody tr td .checkmarkContainer', scope).off 'mousedown'
  $('.timeTable tbody tr td .checkmarkContainer', scope).on 'mousedown', ->
    $(@.parentElement.parentElement).toggleClass 'logSelected'
    $('.checkboxDialogue').not($('.checkboxDialogue', @.parentElement)).fadeOut 'fast'

    if not $('input', @)[0].checked
      $('.checkboxDialogue', @.parentElement).fadeIn 'fast'
    else
      $('.checkboxDialogue', @.parentElement).fadeOut 'fast'

    return


  $('.timeTable tbody tr td .checkboxDialogue .paginationTabsDanger', scope).off 'click'
  $('.timeTable tbody tr td .checkboxDialogue .paginationTabsDanger', scope).on 'click', ->
    $(@.parentElement).fadeOut 'fast'

    table = $(@).parent('tbody')[0]

    $('tr.logSelected', table).removeClass('logSelected')
    $('input:checked', table).forEach((e) ->
      e.checked = false
    )

    window.batch = []
    return


  composer_select_open = ->
    parent = $(@).parent('._Dynamic_Select')
    layer = $('._Dynamic_Layer', parent)

    parent.toggleClass '_Dynamic_Select_Activated'
    $('._Select', parent).toggleClass('selected')
    layer.toggleClass('selected')

    if layer.hasClass 'selected'
      layer.on('click', (e) ->
        composer_select_open.call(@)

        simul = new MouseEvent(e.type, e)
        element = document.elementFromPoint(e.clientX, e.clientY)

        if element.matches('input')
          element.focus()

        parent = $(@).parent('._Dynamic_Select')
        if $('._Title', parent)[0] isnt element
          element.dispatchEvent(simul)

        $(@).off('click')
      )
      $('._Select_Search input', parent)[0].focus()

    return

  $('[data-trigger="[composer/select/open]"]', scope).off 'click'
  $('[data-trigger="[composer/select/open]"]', scope).on 'click', composer_select_open


  selectionData = []
  # when choose selection is buggy af
  $('[data-trigger="[composer/select/choose]"]', scope).off 'click'
  $('[data-trigger="[composer/select/choose]"]', scope).on 'click', (event) ->
    if $('._Title', $(@).parent('._Dynamic_Select'))[0].hasAttribute('data-select-multiple')
      text = $(@).find('p').text()
      checkBox = $(@).find('.checkmarkContainer input')
      if not checkBox.is(':checked')
        checkBox.prop 'checked', true
        selectionData.push text
      else
        checkBox.prop 'checked', false
        i = 0
        while i < selectionData.length
          if selectionData[i] is text
            selectionData.splice i, 1
            break
          i += 1
      $(@).closest('._Dynamic_Select').find('._Title').text '(' + selectionData.length + ') selections'
      return

    parent = $(@).parent('._Dynamic_Select')
    parent.toggleClass '_Dynamic_Select_Activated'
    $('._Select', parent).toggleClass 'selected'
    $('._Dynamic_Layer', parent).toggleClass 'selected'
    $('._Title', parent)[0].textContent = $('p', @)[0].textContent
    $('._Value', parent)[0].value = @.getAttribute('data-value')
    return

  $('[data-trigger="[composer/select/steam]"]', scope).off 'keyup'
  $('[data-trigger="[composer/select/steam]"]', scope).on 'keyup', (e) ->
    value = @.value
    local = @.hasAttribute 'data-email'
    url =
      profile: /^(?:https:\/\/)?steamcommunity\.com\/profiles\/(\d+)$/i.exec value
      id: /^(?:https:\/\/)?steamcommunity\.com\/id\/(.+)$/i.exec value
      email: /^(([^<>()\[\]\\.,;:\s@"]+(\.[^<>()\[\]\\.,;:\s@"]+)*)|(".+"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$/.exec value

    header =
    'X-CSRFToken': window.csrftoken

    if SteamIDConverter.isSteamID(value) or SteamIDConverter.isSteamID3(value)
      value = SteamIDConverter.toSteamID64(value)
    else if url.profile
      value = url.profile[1]
    else if url.id
      value = url.id[1]
    else if local and url.email
      return

    if url.id
      payload = JSON.stringify({'steam': value})
    else if SteamIDConverter.isSteamID64(value)
      payload = JSON.stringify({'steam64': value})
    else if local and url.email
      payload = JSON.stringify({'email': value})
    else
      payload = JSON.stringify({'local': value})

    parent = $(@).parent('._Dynamic_Select')

    $('._Loading', parent).addClass('selected')
    $('._Container', parent)[0].innerHTML = ''
    window.endpoint.ajax.utils.search.post(header, payload, (dummy, response) ->
      $('._Container', parent)[0].innerHTML = response.data
      $('._Loading', parent).removeClass('selected')
      window._.init($('._Container', parent)[0])
      return
    )

  $('[data-trigger="[composer/select/search]"]', scope).off 'keyup'
  $('[data-trigger="[composer/select/search]"]', scope).on 'keyup', (e) ->
    values = []
    input = @.value
    parent = $(@).parent('._Select')
    container = $('._Container', parent)
    $('p', container).forEach((node) ->
      values.push node
      return
    )

    if @.value is ''
      values.forEach((value) ->
        $(value).parent('li')[0].style.display = 'block'
      )

      return

    if e.which >= 90 or e.which <= 48
      return

    distances = []
    values.forEach((value) ->
      $(value).parent('li')[0].style.display = 'none'
      distances.push [value, distance(value.textContent, input)]
    )

    distances.sort((a, b) ->
      return b[1] - a[1]
    )

    distances = distances.slice(0, 5)
    distances.forEach((value) ->
      $(value[0]).parent('li')[0].style.display = 'block'
    )

    return


  $('[data-trigger=\'[ct/switch]\']', scope).off 'click'
  $('[data-trigger=\'[ct/switch]\']', scope).on 'click', ->
    $('.paginationTabSelected', @.parentElement).removeClass('paginationTabSelected')
    hash = @.getAttribute('data')
    $(@).addClass('paginationTabSelected')

    history.replaceState({'location': window._.location, 'scope': window._.scope}, null, "##{hash}")
    window.lazy(@.parentElement.getAttribute('data-target'), '')
    return


  ct_toggle = ->
    parent = @.parentElement
    until parent.nodeName.toLowerCase() is 'tr'
      parent = parent.parentElement

    index = -1
    window.batch.forEach((e) ->
      if e.getAttribute('data-id') is parent.getAttribute('data-id')
        index = window.batch.indexOf(e)
    )
    if index isnt -1
      window.batch.splice(index, 1)

    if @.checked
      window.batch.push(parent)

  $("[data-trigger='[ct/toggle]']", scope).off 'change'
  $("[data-trigger='[ct/toggle]']", scope).on 'change', ct_toggle

  table_choice = ->
    parent = $(@).parent '.modalSelect'

    mode = @.getAttribute('data-mode')
    operation = $('select', parent)[0].value

    switch operation
      when 'delete'
        window.api.remove(mode, window.batch, true)
      when 'edit'
        $('.overlay').fadeIn 'fast'
        modal = $("[data-component='[modal/#{mode}/edit]']")
        modal.fadeIn 'fast'

        if window.batch.length is 1
          $('input.single', modal).removeClass 'hidden'
          $('input.batch', modal).addClass 'hidden'

          target = window.batch[0]
          $('input:not(.skip):not([type=checkbox])', modal).forEach (e) ->
            parent = $(e).parent()
            e.value = target.getAttribute "data-#{e.name}"

            if parent.hasClass '_Dynamic_Select' and e.value
              value = $("._Container li[data-value='#{e.value}'] p", parent)[0].textContent
              $('._Title', parent)[0].textContent = value

        else
          $('input:not(.skip):not([type=checkbox])', modal).forEach (e) ->
            e.value = ''

          $('input.batch', modal).removeClass 'hidden'
          $('input.single', modal).addClass 'hidden'

          button = $('input.batch', modal)[0]
          button.value = button.value.replace /(\d+)/g, window.batch.length

  $("[data-trigger='[table/choice]']", scope).off 'click'
  $("[data-trigger='[table/choice]']", scope).on 'click', table_choice

  $("[data-trigger='[modal/action]']", scope).off 'click'
  $("[data-trigger='[modal/action]']", scope).on 'click', ->
    parent = $(@).parent '.modal'

    mode = @.getAttribute('data-mode')
    action = @.getAttribute('data-action')

    switch action
      when 'delete'
        window.api.remove(mode, parent[0], false)


  $("[data-trigger='[modal/form]']", scope).off 'submit'
  $("[data-trigger='[modal/form]']", scope).on 'submit', (e) ->
    e.preventDefault()

    mode = @.getAttribute('data-mode')
    action = @.getAttribute('data-action')

    switch action
      when 'create'
        window.api.create(mode, @, false)
      when 'edit'
        window.api.edit(mode, @, window.batch.length > 0)

  grid_delete = ->
    parent = $(@).parent '.serverGridItem'

    mode = @.getAttribute('data-mode')
    window.api.remove(mode, parent[0], false)

  $("[data-trigger='[grid/delete]']", scope).off 'click'
  $("[data-trigger='[grid/delete]']", scope).on 'click', grid_delete

  $('[data-trigger="[clip/copy]"]', scope).off 'click'
  $('[data-trigger="[clip/copy]"]', scope).on 'click', (event) ->
    window.style.copy(@.getAttribute('data-clipboard-text'))

  $('[data-trigger="[input/duration]"]', scope).off 'keypress'
  $('[data-trigger="[input/duration]"]', scope).on 'keypress', (event) ->
    event.preventDefault()

    cursor = @.selectionStart

    if not /[PTYDHMS0-9]/.test event.key.toUpperCase() or event.key.length isnt 1
      return

    value = event.target.value
    value = value.substr(0, cursor) + event.key + value.substr(cursor)
    value = value.toUpperCase()
    if value[0] isnt 'P'
      value = 'P' + value
      cursor += 1

    event.target.value = value
    @.setSelectionRange(cursor + 1, cursor + 1)

    try
      $(@).removeClass 'invalid'
      new Duration(value)
    catch e
      $(@).addClass 'invalid'


  # negative range is not supported (yet)
  $('[data-trigger="[input/range]"]', scope).off 'keypress'
  $('[data-trigger="[input/range]"]', scope).on 'keypress', (event) ->
    event.preventDefault()
    cursor = @.selectionStart

    min = @.getAttribute 'data-min'
    max = @.getAttribute 'data-max'

    if not /[0-9]/.test event.key.toUpperCase() or event.key.length isnt 1
      return

    value = event.target.value
    value = value.substr(0, cursor) + event.key + value.substr(cursor)
    value = parseInt(value)

    if value > parseInt(max)
      value = max

    if value < parseInt(min)
      value = min

    event.target.value = value
    @.setSelectionRange(cursor + 1, cursor + 1)

  $('[data-trigger="[select/multiple/double]"]', scope).on 'click', ->
    source = $ @.getAttribute('data-source')
    target = $ @.getAttribute('data-target')

    Array.from(source[0].selectedOptions).forEach (el) ->
      target[0].insertBefore el, target[0].firstChild
  return

menu = ->
  $('.paginationTabs').forEach((i) ->
    for e in i.children
      if window.location.hash and window.location.hash.substring(1) is e.getAttribute('data')
        $(e).addClass('paginationTabSelected')
  )
  return

window._ =
  init: init
  menu: menu

window.batch = []
