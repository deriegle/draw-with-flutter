export interface ILine {
  color: number;
  strokeWidth: number;
  offsets: IOffset[];
}

export interface IOffset {
  x: number;
  y: number;
}

export function parseILineFromString(message: string): ILine[] | null {
  try {
    const json = JSON.parse(message);

    if (!Array.isArray(json)) {
      return null;
    }

    return json
      .filter((blob) => 'color' in blob && 'strokeWidth' in blob && 'offsets' in blob)
      .map((blob) => ({
        color: parseInt(blob.color),
        strokeWidth: parseFloat(blob.strokeWidth),
        offsets: parseOffsetsFromJSON(blob.offsets),
      }));
  } catch (err) {
    console.log({
      err,
      message: 'Error while parsing ILine JSON',
    });
    return null;
  }
}

function parseOffsetsFromJSON(json: any): IOffset[] {
  if (!Array.isArray(json)) {
    return [];
  }

  return json
    .filter((blob) => typeof blob.x === 'number' && typeof blob.y === 'number')
    .map((blob) => ({
      x: blob.x,
      y: blob.y
    }));
}
