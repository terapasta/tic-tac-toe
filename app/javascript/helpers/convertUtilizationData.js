import differenceInDays from 'date-fns/difference_in_days'
import parseDate from 'date-fns/parse'

const HalfYearWeeks = 26
const Week = { Sunday: 0 }

export function convertData(data) {
  const defaultDate = [...data[0]]
  const defaultGm = [...data[1]]
  const defaultQa = [...data[2]]
  const defaultUpdateQa = [...data[3]]

  const defaultData = {
    defaultDate,
    defaultGm,
    defaultQa,
    defaultUpdateQa
  }

  /** MUST UNCOMMNET BEFORE MERGE */
  return (defaultDate.length  /* / 7 */) > HalfYearWeeks
    ? dataToMonthly(defaultData) : dataToWeekly(defaultData)
}

const dataToMonthly = data => {
  const {
    defaultDate,
    defaultGm,
    defaultQa,
    defaultUpdateQa
  } = data

  // set headers
  let dates = [defaultDate.shift()]
  let guestMessages = [defaultGm.shift()]
  let questionAnswers = [defaultQa.shift()]
  let updateQas = [defaultUpdateQa.shift()]

  let baseDate = defaultDate.slice(0, 1)[0]
  let currentMonth = parseDate(baseDate).getMonth()

  defaultDate.forEach((date, i) => {
    const month = parseDate(date).getMonth()
    if (i === 0) {
      dates.push(date)
      guestMessages.push(defaultGm[0])
      questionAnswers.push(defaultQa[0])
      updateQas.push(defaultUpdateQa[0])
    }
    else if (month !== currentMonth) {
      const diffDays = differenceInDays(date, baseDate)

      currentMonth = month
      baseDate = parseDate(date)

      dates.push(date)
      guestMessages.push(calcData(defaultGm, i, i + diffDays))
      questionAnswers.push(defaultQa[i] || 0)
      updateQas.push(calcData(defaultUpdateQa, i, i + diffDays))
    }
  })

  return [
    [...dates],
    [...guestMessages],
    [...questionAnswers],
    [...updateQas]
  ]
}

const dataToWeekly = data => {
  const {
    defaultDate,
    defaultGm,
    defaultQa,
    defaultUpdateQa
  } = data

  // set headers
  let dates = [defaultDate.shift()]
  let guestMessages = [defaultGm.shift()]
  let questionAnswers = [defaultQa.shift()]
  let updateQas = [defaultUpdateQa.shift()]

  defaultDate.forEach((date, i) => {
    const day = parseDate(date).getDay()

    if (i === 0 && day !== Week.Sunday) {
      // data for first week -> previous Sunday to yesterday
      dates.push(date)
      guestMessages.push(calcData(defaultGm, 0, day))
      questionAnswers.push(defaultQa[i] || 0)
      updateQas.push(calcData(defaultUpdateQa, 0, day))
    }
    else if (day === Week.Sunday) {
      dates.push(date)
      guestMessages.push(calcData(defaultGm, i, i + 7))
      questionAnswers.push(defaultQa[i] || 0)
      updateQas.push(calcData(defaultUpdateQa, i, i + 7))
    }
  })

  return [
    [...dates],
    [...guestMessages],
    [...questionAnswers],
    [...updateQas]
  ]
}

export function convertDataForGm(data) {
  const defaultDate = [...data[0]]
  const defaultGm = [...data[1]]

  const defaultData = { defaultDate, defaultGm }

  /** MUST UNCOMMNET BEFORE MERGE */
  return (defaultDate.length  /* / 7 */) > HalfYearWeeks
    ? dataToMonthlyForGm(defaultData) : dataToWeeklyForGm(defaultData)
}

const dataToMonthlyForGm = data => {
  const { defaultDate, defaultGm } = data

  // set headers
  let dates = [defaultDate.shift()]
  let guestMessages = [defaultGm.shift()]

  let baseDate = defaultDate.slice(0, 1)[0]
  let currentMonth = parseDate(baseDate).getMonth()

  defaultDate.forEach((date, i) => {
    const month = parseDate(date).getMonth()

    if (i === 0) {
      dates.push(date)
      guestMessages.push(defaultGm[0])
    }
    else if (month !== currentMonth) {
      const diffDays = differenceInDays(date, baseDate)

      currentMonth = month
      baseDate = parseDate(date)
      dates.push(date)
      guestMessages.push(calcData(defaultGm, i, i + diffDays))
    }
  })

  return [
    [...dates],
    [...guestMessages]
  ]

}

const dataToWeeklyForGm = data => {
  const { defaultDate, defaultGm } = data

  // set headers
  let dates = [defaultDate.shift()]
  let guestMessages = [defaultGm.shift()]

  defaultDate.forEach((date, i) => {
    const day = parseDate(date).getDay()

    if (i === 0 && day !== Week.Sunday) {
      // data for first week -> previous Sunday to yesterday
      dates.push(date)
      guestMessages.push(calcData(defaultGm, 0, day))
    }
    else if (day === Week.Sunday) {
      dates.push(date)
      guestMessages.push(calcData(defaultGm, i, i + 7))
    }
  })

  return [
    [...dates],
    [...guestMessages]
  ]
}

const calcData = (defaultData, start, end) => {
  if (!defaultData || !defaultData[start]) { return 0 }
  return defaultData.slice(start, end).reduce((acc, val) => acc + val)
}
