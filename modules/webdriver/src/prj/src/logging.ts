type LogLevel = 'debug' | 'info' | 'warn' | 'error';

export let MIN_LEVEL: LogLevel = 'info';

const LEVELS: {[key in LogLevel]: number} = {
	'debug': 10,
	'info': 20,
	'warn': 30,
	'error': 40
};

export function log(level: LogLevel, message: string, data?: {[key: string]: any}): void {
	if (LEVELS[level] < LEVELS[MIN_LEVEL]) {
		return;
	}

	console.log({
		level,
		message,
		...data
	})
}
