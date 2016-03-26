<?php
  echo "Hostname     : " . gethostname();
  echo "<br>";
  echo "PHP Server IP: " . $_SERVER['SERVER_ADDR'];
  echo "<br>";
  echo "Container IP : " . shell_exec("cat /etc/hosts |grep -m 1 web.docker.demo");
?>
