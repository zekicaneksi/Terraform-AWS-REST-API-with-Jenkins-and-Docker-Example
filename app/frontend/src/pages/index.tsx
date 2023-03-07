import {useState} from 'react'
import Head from 'next/head'
import Image from 'next/image'
import { Inter } from '@next/font/google'
import styles from '@/styles/Home.module.css'

const inter = Inter({ subsets: ['latin'] })

const fetchData = () => {
	fetch(process.env.NEXT_PUBLIC_BACKEND_ADDRESS+"/someData", {credentials : "include", mode: "cors",
headers: {
	"Content-Type": "application/json"
    }
})
  .then((response) => response.json())
  .then((data) => setText(data));

}

export default function Home() {

	const [text, setText] = useState('click the button')

  return (
    <>
	<button onClick={fetchData}>fetch data from backend</button>
      <p>{text}</p>
	<p>backend address:{process.env.NEXT_PUBLIC_BACKEND_ADDRESS}</p>
    </>
  )
}
