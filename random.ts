export const random = (...arr: any[]) => {
  arr = arr.flat(1);
  return arr[between(0, arr.length)];
};

export const between = (min: number, max: number) =>
  Math.floor(Math.random() * (max - min + 1) + min);
