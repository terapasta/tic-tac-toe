import differenceInDays from 'date-fns/difference_in_days'
import dateFnsformatDate from 'date-fns/format'
import parseDate from 'date-fns/parse'
import jaLocale from 'date-fns/locale/ja'
import subDays from 'date-fns/sub_days'

import flatten from 'lodash/flatten'

const DateFormat = 'YYYY-MM-DD'
const formatDate = date => dateFnsformatDate(date, DateFormat, { locale: jaLocale })

const Week = { Sunday: 0 }
const OneWeekAgo = subDays(new Date(), 7)
const MonthlyBreakPoint = 27
const HalfYearDays = 182

const DataConversionBreakPoint = 31

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
  let startIndex = defaultDates.indexOf(formatDate(OneWeekAgo))
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
  let startIndex = defaultDates.indexOf(formatDate(OneWeekAgo))
  if (startIndex === -1) { startIndex = lastIndex - 7 }

  return [
    flatten([...dates, defaultDates.slice(startIndex, lastIndex)]),
    flatten([...guestMessages, defaultGms.slice(startIndex, lastIndex)])
  ]
}

export function convertData(_data) {
  if (_data[0].length <= DataConversionBreakPoint) {
    return _data
  }

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
  let monthlyGms = 0, monthlyQas = 0, monthlyUpdateQas = 0
  let currentMonth = parseDate(defaultDate[0]).getMonth()

  defaultDate.forEach((date, i) => {
    monthlyGms += defaultGm[i]
    monthlyQas += defaultQa[i]
    monthlyUpdateQas += defaultUpdateQa[i]
    const month = parseDate(date).getMonth()
    if (month !== currentMonth || i === defaultDate.lenghth - 1) {
      dates.push(date)
      guestMessages.push(monthlyGms)
      questionAnswers.push(monthlyQas)
      updateQas.push(monthlyUpdateQas)
      
      currentMonth = month
      monthlyGms = monthlyQas = monthlyUpdateQas = 0
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
  let weeklyGms = 0, weeklyQas = 0, weeklyUpdateQas = 0

  defaultDate.forEach((date, i) => {
    weeklyGms += defaultGm[i]
    weeklyQas += defaultQa[i]
    weeklyUpdateQas += defaultUpdateQa[i]

    if (
      parseDate(date).getDay() === Week.Sunday ||
      i === defaultDate.length - 1
    ) {
      dates.push(date)
      guestMessages.push(weeklyGms)
      questionAnswers.push(weeklyQas)
      questionAnswers.push(weeklyUpdateQas)
      weeklyGms = weeklyQas = weeklyUpdateQas = 0
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
  if (_data[0].length <= DataConversionBreakPoint) {
    return [_data[0], _data[1]]
  }

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
  let monthlyGms = 0
  let currentMonth = parseDate(defaultDate[0]).getMonth()

  defaultDate.forEach((date, i) => {
    const month = parseDate(date).getMonth()
    monthlyGms += defaultGm[i]
    if (month !== currentMonth || i === defaultDate.length - 1) {
      dates.push(date)
      guestMessages.push(monthlyGms)
      currentMonth = month
      monthlyGms = 0
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
  let weeklyGms = 0

  defaultDate.forEach((date, i) => {
    weeklyGms += defaultGm[i]
    if (
      parseDate(date).getDay() === Week.Sunday ||
      i === defaultDate.length -1
    ) {
      dates.push(date)
      guestMessages.push(weeklyGms)
      weeklyGms = 0
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
