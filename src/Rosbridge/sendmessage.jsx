import React, { useState } from 'react';
import ROSLIB from 'roslib';
import rosBridgeClient from './rosBridgeClient'; // Adjust the path according to your project structure

function SendMessage() {
  const [status, setStatus] = useState('Not connected');
  const [counter, setCounter] = useState(1);

  const ros = rosBridgeClient();

  function publish() {
    if (!ros.isConnected) {
      setStatus('Not connected');
      return;
    }

    const cmdVel = new ROSLIB.Topic({
      ros: ros,
      name: 'my_topic',
      messageType: 'std_msgs/String',
    });

    const data = new ROSLIB.Message({
      data: counter,
    });

    console.log('Publishing message:', data);
    cmdVel.publish(data);

    setCounter((prevCounter) => prevCounter + 1);
  }

  return (
    <div>
      <div>{status}</div>
      <br />
      <button onClick={publish}>Publish</button>
      <div>publishing {counter}</div>
      <br />
    </div>
  );
}

export default SendMessage;
