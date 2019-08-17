declare module "@unpourtous/react-native-custom-keyboard" {

  import {Component} from "react"
  import {ComponentProvider, TextInputProps} from "react-native"

  export function register(type: string, keyboardInfo: { factory: ComponentProvider, height?: number }): void

  interface Props extends TextInputProps {
    customKeyboardType: string
  }

  export class CustomTextInput extends Component<Props, any> {
  }

  export class InputAssistantDisabledTextInput extends Component<TextInputProps, any> {
  }

  export function backSpace(tag: string): void

  export function submit(tag: string): void

  export function insertText(tag: string, text: string): void

  export interface KeyboardProps {
    tag: string
  }
}
