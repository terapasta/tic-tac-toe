document.addEventListener('DOMContentLoaded', () => {
  const itemSelection = [].slice.call(document.querySelectorAll('[data-role="deleteable-item"]'))
  const allItemSelection = document.querySelector('[data-role="all-deleteable-items"]')
  const bulkDeleteButton = document.querySelector('[data-role=bulk-delete-button]')
  if (itemSelection.length === 0) { return }

  let selectedItemIds = []

  itemSelection.forEach(it => {
    const cb = it.querySelector('input[type=checkbox]')
    const checkboxHandler = (e) => {
      if (e) { e.stopPropagation() }
      const id = window.parseInt(cb.value)
      if (cb.checked && selectedItemIds.indexOf(id) === -1) {
        selectedItemIds.push(id)
      } else {
        selectedItemIds = selectedItemIds.filter(it => it !== id)
      }
      console.log(selectedItemIds)
    }

    it.addEventListener('click', () => {
      cb.checked = !cb.checked
      checkboxHandler()
    })

    cb.addEventListener('click', e => e.stopPropagation())
    cb.addEventListener('change', checkboxHandler)
  })

  allItemSelection.addEventListener('change', () => {
    if (allItemSelection.checked) {
      let ids = []
      itemSelection.forEach(it => {
        const cb = it.querySelector('input[type=checkbox]')
        cb.checked = true
        ids.push(window.parseInt(cb.value))
      })
      selectedItemIds = ids
    } else {
      itemSelection.forEach(it => {
        it.querySelector('input[type=checkbox]').checked = false
      })
      selectedItemIds = []
    }
  })

  setInterval(() => {
    bulkDeleteButton.disabled = selectedItemIds.length === 0
  }, 100)
})
