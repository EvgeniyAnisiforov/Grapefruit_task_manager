import {FC} from 'react'
import { Input } from "antd"
import { useNavigate } from 'react-router-dom'
import {useForm, Controller, SubmitHandler} from 'react-hook-form'
import { usePostRegMutation } from '../redux/API/RegApi'

type PasswordDataType = {
  name: string,
  surname: string,
  login: string,
  passwd: string
}

const Reg: FC<{}> = () => {
    const [reg] = usePostRegMutation()
    const navigate = useNavigate()
    const goAuth = () => navigate("/")

    const {
      control,
      reset,
      formState: {
        errors
      },
      handleSubmit,
    } = useForm<PasswordDataType>()

    const onSubmit:SubmitHandler<PasswordDataType> = async (data) => {
      try{
        alert(JSON.stringify({name: data.name, surname: data.surname, login: data.login, passwd: data.passwd}))
        const result = await reg({name: data.name, surname: data.surname, login: data.login, passwd: data.passwd}).unwrap()
        if(result){
          goAuth()
        }
      }catch (errors){
        console.log("ошибка")
      }
      reset()
    }

    return (
        <div className="w-screen h-screen">
          <div className="w-full h-full bg-gradient-to-l from-red-500 to-orange-500 flex justify-center items-center">
            <div className="pb-[100px]">
              <h1 className="text-5xl text-white max-[1500px]:text-4xl max-[400px]:text-3xl">Регистрация</h1>
              <form onSubmit={handleSubmit(onSubmit)} className="mt-5 w-full flex flex-col justify-center items-center">
                <Controller
                name="name"
                control={control}
                rules={{required: 'Заполните поле имени!'}}
                render={({field})=>(
                  <Input {...field} placeholder="Имя" className={`m-2 w-[450px] h-12 rounded-xl max-[1500px]:w-[400px] max-[450px]:w-[350px] max-[400px]:w-[300px] ${
                    errors.name ? "border-red-500" : ""
                  }`}/>
                )}
              />
              {errors.name && typeof errors.name.message === "string" && (
                <p className="text-white text-xl">{errors.name.message}</p>
              )}
              <Controller
                name="surname"
                control={control}
                rules={{required: 'Заполните поле фамилии!'}}
                render={({field})=>(
                  <Input {...field} placeholder="Фамилия" className={`m-2 w-[450px] h-12 rounded-xl max-[1500px]:w-[400px] max-[450px]:w-[350px] max-[400px]:w-[300px] ${
                    errors.surname ? "border-red-500" : ""
                  }`}/>
                )}
              />
              {errors.surname && typeof errors.surname.message === "string" && (
                <p className="text-white text-xl">{errors.surname.message}</p>
              )}
              <Controller
                name="login"
                control={control}
                rules={{required: 'Заполните поле логин!'}}
                render={({field})=>(
                  <Input {...field} placeholder="Логин" className={`m-2 w-[450px] h-12 rounded-xl max-[1500px]:w-[400px] max-[450px]:w-[350px] max-[400px]:w-[300px] ${
                    errors.login ? "border-red-500" : ""
                  }`}/>
                )}
              />
              {errors.login && typeof errors.login.message === "string" && (
                <p className="text-white text-xl">{errors.login.message}</p>
              )}
              <Controller
                name="passwd"
                control={control}
                rules={{required: 'Заполните поле пароль!'}}
                render={({field})=>(
                  <Input {...field} placeholder="Пароль" className={`m-2 w-[450px] h-12 rounded-xl max-[1500px]:w-[400px] max-[450px]:w-[350px] max-[400px]:w-[300px] ${
                    errors.passwd ? "border-red-500" : ""
                  }`}/>
                )}
              />
              {errors.passwd && typeof errors.passwd.message === "string" && (
                <p className="text-white text-xl">{errors.passwd.message}</p>
              )}
              <div className='mt-3'><a onClick={goAuth} className="cursor-pointer hover:underline hover:text-blue-400 text-white text-2xl max-[1500px]:text-xl max-[400px]:text-lg">Вернуться назад?</a></div>
              <button type='submit' className="bg-yellow-400 rounded-xl mt-5 px-3 py-1 text-white text-3xl shadow-[0_0_10px_rgb(250_204_21)] hover:bg-yellow-500 transition duration-300 ease-in-out focus:outline-none max-[1500px]:text-2xl">Войти</button>
              </form>
            </div>
          </div>
        </div>
      )
}
export {Reg}