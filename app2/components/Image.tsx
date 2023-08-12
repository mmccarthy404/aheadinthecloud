// import NextImage, { ImageProps } from 'next/image'
import { ImageProps } from 'next/image'

// const Image = ({ ...rest }: ImageProps) => <NextImage {...rest} />
const Image = ({ ...rest }: ImageProps) => <img {...rest} />

export default Image
