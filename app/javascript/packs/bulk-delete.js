document.addEventListener('DOMContentLoaded', () => {
  const itemSelection = [].slice.call(document.querySelectorAll('[data-role="deleteable-item"]'))
  const allItemSelection = document.querySelector('[data-role="all-deleteable-items"]')
  const bulkDeleteButton = document.querySelector('[data-role=bulk-delete-button]')

  // 初期状態は何も選択されていない状態なので、ボタンを無効化しておく
  bulkDeleteButton.disabled = true;

  if (itemSelection.length === 0) { return }

  let selectedItemIds = []

  itemSelection.forEach(it => {
    const cb = it.querySelector('input[type=checkbox]')
    const checkboxHandler = (e) => {
      if (e) { e.stopPropagation() }
      const id = window.parseInt(cb.value)
      const itemIndex = selectedItemIds.indexOf(id);
      if (cb.checked && itemIndex === -1) {
        selectedItemIds.push(id)
      } else {
        selectedItemIds.splice(itemIndex, 1);
      }
      console.log(selectedItemIds)

      // アイテムが選択された際に何も選択されていなければボタンを無効化する
      bulkDeleteButton.disabled = selectedItemIds.length === 0
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

    // アイテムが選択された際に何も選択されていなければボタンを無効化する
    // 個別の checkbox の changeイベントは発生しないので、
    // 独自に判定を行う必要がある
    bulkDeleteButton.disabled = selectedItemIds.length === 0
  })
})
