import React from 'react'
import PropTypes from 'prop-types'
import DatePicker from 'react-datepicker'
import { registerLocale, setDefaultLocale } from  "react-datepicker"
import ru from 'date-fns/locale/ru'
import _ from 'underscore'

registerLocale('ru', ru)
setDefaultLocale('ru');

class BenchkillerPeriodForm extends React.Component {
  constructor(props) {
    super(props)

    this.state = {
      variousPeriodShowState: props.params.period === 'various_period' ? 'show' : 'hidden',
      beginDate: _.isEmpty(props.params.begin_date) ? '' : Date.parse(props.params.begin_date.split('.').reverse().join('-')),
      endDate: _.isEmpty(props.params.end_date) ? '' : Date.parse(props.params.end_date.split('.').reverse().join('-')),
    }

    this.toggle = this.toggle.bind(this)
    this.change = this.change.bind(this)
    this.datePickerChange = this.datePickerChange.bind(this)
  }

  toggle(showState) {
    this.setState({
      variousPeriodShowState: showState
    })
  }

  change(value) {
    if (value == 'various_period') {
      this.toggle('show')
    } else {
      this.toggle('hidden')
    }
  }

  datePickerChange(name, date) {
    this.setState({
      [name]: date
    })
  }

  render() {
    let variousPeriodInputs = <></>
    if (this.state.variousPeriodShowState == 'show') {
      variousPeriodInputs = (
        <div className='mt-3' style={{ display: 'flex', 'flexDirection': 'row', 'justifyContent': 'space-between' }}>
          <div className='mr-2'>
            <label>От</label>
            <DatePicker dateFormat="dd.MM.yyyy" selected={this.state.beginDate} onChange={(date) => { this.datePickerChange('beginDate', date) }} name="begin_date" id="begin_date" className="text form-control" locale="ru" />
          </div>
          <div>
            <label>До</label>
            <DatePicker dateFormat="dd.MM.yyyy" selected={this.state.endDate} onChange={(date) => { this.datePickerChange('endDate', date) }} name="end_date" id="end_date" className="text form-control datepicker" locale="ru" />
          </div>
        </div>
      )
    }

    const periods = {
      day: 'День',
      week: 'Неделя',
      month: 'Месяц',
      quarter: 'Квартал',
      various_period: 'Произвольный период'
    }

    return (
        <div className='mb-3'>
          <div className='mt-2'>
            <select onChange={(e) => { this.change(e.target.value) }} defaultValue={this.props.params.period} name="period" id="period" className="form-select form-control">
              {
                _.keys(periods).map((key) => {
                  return (
                    <option key={key} value={key}>{periods[key]}</option>
                  )
                })
              }
            </select>
          </div>
          { variousPeriodInputs }
        </div>
     )
  }
}

export default BenchkillerPeriodForm
