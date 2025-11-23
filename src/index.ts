export function greet(name: string): string {
  return `Hello, ${name}!`;
}

export function add(a: number, b: number): number {
  return a + b;
}

export class Calculator {
  constructor(private initialValue: number = 0) {}

  add(value: number): this {
    this.initialValue += value;
    return this;
  }

  subtract(value: number): this {
    this.initialValue -= value;
    return this;
  }

  getResult(): number {
    return this.initialValue;
  }
}
