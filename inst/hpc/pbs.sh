#!/bin/bash
DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
pushd $DIR > /dev/null

# job chain
MODEL1=$(qsub model.pbs)
HYPER=$(qsub -W depend=afterokarray:$MODEL1 hyper.pbs)
MODEL2=$(qsub -W depend=afterok:$HYPER model.pbs)
OUTPUT=$(qsub -W depend=afterokarray:$MODEL2 output.pbs)
EXITCODE=$?

# clean up
if [[ $EXITCODE != 0 ]]; then
  qdel $MODEL1 $HYPER $MODEL2 $OUTPUT
  echo Failed to submit jobs!
else
  echo Submitted jobs! To cancel execute:
  echo qdel $MODEL1 $HYPER $MODEL2 $OUTPUT
fi

popd > /dev/null
exit $EXITCODE
