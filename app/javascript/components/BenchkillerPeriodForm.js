import React from 'react'
import PropTypes from 'prop-types'
import DatePicker from 'react-datepicker'
import 'react-datepicker/dist/react-datepicker.css'
import { registerLocale, setDefaultLocale } from  "react-datepicker";
import ru from 'date-fns/locale/ru';
registerLocale('ru', ru)
setDefaultLocale('ru');

class BenchkillerPeriodForm extends React.Component {
  constructor(props) {
    super(props)

    this.state = {
      variousPeriodShowState: 'hidden',
      beginDate: '',
      endDate: ''
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

    return (
        <div className='mb-3'>
          <div className='mt-2'>
            <select onChange={(e) => { this.change(e.target.value) }} name="period" id="period" className="form-select form-control">
              <option value="day">День</option>
              <option value="week">Неделя</option>
              <option value="month">Месяц</option>
              <option value="quarter">Квартал</option>
              <option value="various_period">Произвольный период</option>
            </select>
          </div>
          { variousPeriodInputs }
        </div>
     )
  }
}

export default BenchkillerPeriodForm
