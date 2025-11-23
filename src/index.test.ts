import { greet, add, Calculator } from './index';

describe('greet', () => {
  it('should greet by name', () => {
    expect(greet('World')).toBe('Hello, World!');
  });
});

describe('add', () => {
  it('should add two numbers', () => {
    expect(add(2, 3)).toBe(5);
  });
});

describe('Calculator', () => {
  it('should initialize with default value', () => {
    const calc = new Calculator();
    expect(calc.getResult()).toBe(0);
  });

  it('should add values', () => {
    const calc = new Calculator(10);
    expect(calc.add(5).getResult()).toBe(15);
  });

  it('should subtract values', () => {
    const calc = new Calculator(10);
    expect(calc.subtract(3).getResult()).toBe(7);
  });

  it('should chain operations', () => {
    const calc = new Calculator(10);
    expect(calc.add(5).subtract(3).add(2).getResult()).toBe(14);
  });
});
