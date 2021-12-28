String env = (const String.fromEnvironment('ENV') == 'production')
  ? 'production' : 'develop';

const APP_NAME_SUFFIX = {
  'develop': ' Test',
  'production': ''
};
