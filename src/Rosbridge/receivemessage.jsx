import React, { useState, useEffect } from 'react';
import ROSLIB from 'roslib';
import rosBridgeClient from './rosBridgeClient';

function ReceiveMessage() {
  const [receivedMessage, setReceivedMessage] = useState('');

  useEffect(() => {
    const ros = rosBridgeClient();

    const listener = new ROSLIB.Topic({
      ros: ros,
      name: 'my_topic',
      messageType: 'std_msgs/String',
    });

    listener.subscribe((message) => {
      console.log('Received message:', message.data);
      setReceivedMessage(message.data);
    });

    return () => {
      listener.unsubscribe();
    };
  }, []);

  return (
    <div>
      <div>Received Message: {receivedMessage}</div>
    </div>
  );
}

export default ReceiveMessage;
