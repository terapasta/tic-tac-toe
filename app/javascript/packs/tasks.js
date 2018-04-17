import rails from 'rails-ujs'

document.addEventListener('DOMContentLoaded', () => {
  const taskSelectings = [].slice.call(document.querySelectorAll('[data-role="task-selecting"]'))
  const allTaskSelecting = document.querySelector('[data-role="all-task-selecting"]')
  const bulkCompleteButton = document.querySelector('[data-role=bulk-complete-button]')
  if (taskSelectings.length === 0) { return }

  let selectedTaskIds = []

  taskSelectings.forEach(it => {
    const cb = it.querySelector('input[type=checkbox]')
    const checkboxHandler = (e) => {
      if (e) { e.stopPropagation() }
      const id = window.parseInt(cb.value)
      if (cb.checked && selectedTaskIds.indexOf(id) === -1) {
        selectedTaskIds.push(id)
      } else {
        selectedTaskIds = selectedTaskIds.filter(it => it !== id)
      }
      console.log(selectedTaskIds)
    }

    it.addEventListener('click', () => {
      cb.checked = !cb.checked
      checkboxHandler()
    })

    cb.addEventListener('click', e => e.stopPropagation())
    cb.addEventListener('change', checkboxHandler)
  })

  allTaskSelecting.addEventListener('change', () => {
    if (allTaskSelecting.checked) {
      let ids = []
      taskSelectings.forEach(it => {
        const cb = it.querySelector('input[type=checkbox]')
        cb.checked = true
        ids.push(window.parseInt(cb.value))
      })
      selectedTaskIds = ids
    } else {
      taskSelectings.forEach(it => {
        it.querySelector('input[type=checkbox]').checked = false
      })
      selectedTaskIds = []
    }
  })

  setInterval(() => {
    bulkCompleteButton.disabled = selectedTaskIds.length === 0
    const url = bulkCompleteButton.parentNode.action.replace(/\?.+$/, '')
    bulkCompleteButton.parentNode.action = `${url}?task_ids=${selectedTaskIds.join(',')}`
  }, 100)
})
