import {FC} from 'react'
import { Input } from "antd"
import { useNavigate } from 'react-router-dom'

const Reg: FC<{}> = () => {
    const navigate = useNavigate()
    const goAuth = () => navigate("/")
    return (
        <div className="w-screen h-screen">
          <div className="w-full h-full bg-gradient-to-l from-red-500 to-orange-500">
            <div className="pt-64">
              <h1 className="text-5xl text-white">Регистрация</h1>
              <div className="mt-5 w-full flex flex-col justify-center items-center">
                <Input className="m-2 w-1/4 h-12 rounded-xl" placeholder="Имя" />
                <Input className="m-2 w-1/4 h-12 rounded-xl" placeholder="Фамилия" />
                <Input className="m-2 w-1/4 h-12 rounded-xl" placeholder="Логин" />
                <Input className="m-2 w-1/4 h-12 rounded-xl" placeholder="Пароль" />
              </div>
              <div><a onClick={goAuth} className="cursor-pointer hover:underline hover:text-blue-400 text-white text-2xl">Вернуться назад?</a></div>
              <button className="bg-yellow-400 rounded-xl mt-5 px-3 py-1 text-white text-3xl shadow-[0_0_10px_rgb(250_204_21)] hover:bg-yellow-500 transition duration-300 ease-in-out focus:outline-none">Войти</button>
            </div>
          </div>
        </div>
      )
}
export {Reg}