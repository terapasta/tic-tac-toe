import differenceInDays from 'date-fns/difference_in_days'
import dateFnsformatDate from 'date-fns/format'
import parseDate from 'date-fns/parse'
import jaLocale from 'date-fns/locale/ja'
import subDays from 'date-fns/sub_days'

import flatten from 'lodash/flatten'

const DateFormat = 'YYYY-MM-DD'
const formatDate = date => dateFnsformatDate(date, DateFormat, { locale: jaLocale })
const today = new Date()
const oneWeekAgo = subDays(today, 7)
const MonthlyBreakPoint = 27
const HalfYearDays = 182
const Week = { Sunday: 0 }

export function oneWeekData(_data) {
  const defaultDates = [..._data[0]]
  const defaultGms = [..._data[1]]
  const defaultQas = [..._data[2]]
  const defaultUpdateQas = [..._data[3]]

  // set headers
  let dates = [defaultDates.shift()]
  let guestMessages = [defaultGms.shift()]
  let questionAnswers = [defaultQas.shift()]
  let updateQas = [defaultUpdateQas.shift()]

  const lastIndex = defaultDates.length
  let startIndex = defaultDates.indexOf(formatDate(oneWeekAgo))
  if (startIndex === -1) { startIndex = lastIndex - 7 }

  return [
    flatten([...dates, defaultDates.slice(startIndex, lastIndex)]),
    flatten([...guestMessages, defaultGms.slice(startIndex, lastIndex)]),
    flatten([...questionAnswers, defaultQas.slice(startIndex, lastIndex)]),
    flatten([...updateQas, defaultUpdateQas.slice(startIndex, lastIndex)])
  ]
}

export function oneWeekDataForGm(_data) {
  const defaultDates = [..._data[0]]
  const defaultGms = [..._data[1]]

  // set headers
  let dates = [defaultDates.shift()]
  let guestMessages = [defaultGms.shift()]

  const lastIndex = defaultDates.length
  let startIndex = defaultDates.indexOf(formatDate(oneWeekAgo))
  if (startIndex === -1) { startIndex = lastIndex - 7 }

  return [
    flatten([...dates, defaultDates.slice(startIndex, lastIndex)]),
    flatten([...guestMessages, defaultGms.slice(startIndex, lastIndex)])
  ]
}

export function convertData(_data) {
  const defaultData = {
    defaultDate: [..._data[0]],
    defaultGm: [..._data[1]],
    defaultQa: [..._data[2]],
    defaultUpdateQa: [..._data[3]]
  }

  // set headers
  const data = {
    dates: [defaultData.defaultDate.shift()],
    guestMessages: [defaultData.defaultGm.shift()],
    questionAnswers: [defaultData.defaultQa.shift()],
    updateQas: [defaultData.defaultUpdateQa.shift()]
  }

  return shouldMonthly(defaultData.defaultDate)
    ? dataToMonthly(defaultData, data)
    : dataToWeekly(defaultData, data)
}

const dataToMonthly = (defaultData, data) => {
  const { defaultDate, defaultGm, defaultQa, defaultUpdateQa } = defaultData
  let { dates, guestMessages, questionAnswers, updateQas } = data

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

const dataToWeekly = (defaultData, data) => {
  const { defaultDate, defaultGm, defaultQa, defaultUpdateQa } = defaultData
  let { dates, guestMessages, questionAnswers, updateQas } = data

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

export function convertDataForGm(_data) {
  const defaultData = {
    defaultDate: [..._data[0]],
    defaultGm: [..._data[1]]
  }

  // set headers
  const data = {
    dates: [defaultData.defaultDate.shift()],
    guestMessages: [defaultData.defaultGm.shift()]
  }

  return shouldMonthly(defaultData.defaultDate)
    ? dataToMonthlyForGm(defaultData, data)
    : dataToWeeklyForGm(defaultData, data)
}

const dataToMonthlyForGm = (defaultData, data) => {
  const { defaultDate, defaultGm } = defaultData
  let { dates, guestMessages } = data

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

const dataToWeeklyForGm = (defaultData, data) => {
  const { defaultDate, defaultGm } = defaultData
  let { dates, guestMessages } = data

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

const shouldMonthly = dates => {
  const lastIndex = dates.length - 1
  const diffDays = differenceInDays(dates[lastIndex], dates[0])
  return diffDays > HalfYearDays && dates.length > MonthlyBreakPoint

}

const calcData = (defaultData, start, end) => {
  if (!defaultData || !defaultData[start]) { return 0 }
  return defaultData.slice(start, end).reduce((acc, val) => acc + val)
}
