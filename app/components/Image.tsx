// import NextImage, { ImageProps } from 'next/image'

// const Image = ({ ...rest }: ImageProps) => <NextImage {...rest} />
const Image = ({ ...rest }: React.DetailedHTMLProps<React.ImgHTMLAttributes<HTMLImageElement>, HTMLImageElement>) => <img {...rest} />

export default Image
