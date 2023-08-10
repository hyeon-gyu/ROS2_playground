import ROSLIB from 'roslib';

const rosBridgeClient = () => {
  const ros = new ROSLIB.Ros({ url: 'ws://localhost:9090' }); // Change the URL if ROS Bridge is running on a different address

  ros.on('connection', () => {
    console.log('Connected to ROS Bridge!');
  });

  ros.on('error', (error) => {
    console.error('Error connecting to ROS Bridge:', error);
  });

  ros.on('close', () => {
    console.log('Connection to ROS Bridge closed.');
  });

  return ros;
};

export default rosBridgeClient;
