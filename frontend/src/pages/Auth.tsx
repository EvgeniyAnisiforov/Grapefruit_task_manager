import { FC } from "react"
import { Input } from "antd"
import { useNavigate } from "react-router-dom"

const Auth: FC<{}> = () => {

  const navigate = useNavigate()
  const goReg = () => navigate('/reg')

  return (
    <div className="w-screen h-screen">
      <div className="w-full h-full bg-gradient-to-l from-red-500 to-orange-500 flex justify-center items-center">
        <div className="pb-[100px]">
          <h1 className="text-5xl text-white max-[1500px]:text-4xl max-[400px]:text-3xl">Авторизация</h1>
          <div className="mt-5 w-full flex flex-col justify-center items-center">
            <Input className="m-2 w-[450px] h-12 rounded-xl max-[1500px]:w-[400px] max-[450px]:w-[350px] max-[400px]:w-[300px]" placeholder="Логин" />
            <Input className="m-2 w-[450px] h-12 rounded-xl max-[1500px]:w-[400px] max-[450px]:w-[350px] max-[400px]:w-[300px]"  placeholder="Пароль" />
          </div>
          <p className="text-white text-2xl max-[1500px]:text-xl max-[400px]:text-lg">У вас нет аккаунта? <a onClick={goReg} className="cursor-pointer hover:underline hover:text-blue-400">Регистрация</a></p>
          <button className="bg-yellow-400 rounded-xl mt-5 px-3 py-1 text-white text-3xl shadow-[0_0_10px_rgb(250_204_21)] hover:bg-yellow-500 transition duration-300 ease-in-out focus:outline-none max-[1500px]:text-2xl">Войти</button>
        </div>
      </div>
    </div>
  )
}
export { Auth }
